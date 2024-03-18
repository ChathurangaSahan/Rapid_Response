const express = require("express");
const router = express.Router();
var admin = require("firebase-admin");
const serviceAccount = require("../rapid-response-802d3-firebase-adminsdk-n69t0-43af2556f7.json");
const authMiddleware = require("../middleware/authMiddleware");
const { Civilian } = require("../models/civilian");
const { FirstResponder } = require("../models/first-responder");
const { Notification, validate } = require("../models/notification");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Get latest notifications
router.get("/latest/:count", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  const { count } = req.params;

  if (!userId || !count || isNaN(parseInt(count)) || parseInt(count) <= 0)
    return res.status(400).send("Bad Request");

  try {
    const notifications = await Notification.find({
      to: userId,
    })
      .select("_id type from title body timestamp")
      .sort({ timestamp: -1 })
      .limit(parseInt(count));

    if (notifications.length < 1)
      return res.status(404).send("No notifications found for the user");

    return res.status(200).send(notifications);
  } catch (error) {
    console.log("Error: ", error);
    return res.status(500).send("Internal Server Error");
  }
});

// Check if a request has been already sent to the intended user
router.get(
  "/search/request/:intendedUserId",
  authMiddleware,
  async (req, res) => {
    const currentUserId = req.user.id;
    const { intendedUserId } = req.params;
    const { type } = req.query;

    if (!currentUserId || !intendedUserId || !type)
      return res.status(400).send("Bad Request");

    const [civilian, firstResponder] = await Promise.all([
      Civilian.findById(intendedUserId).select("notifications"),
      FirstResponder.findById(intendedUserId).select("notifications"),
    ]);

    const user = civilian || firstResponder;

    if (!user)
      return res.status(400).send("Intended user with given id not found");

    const notifications = await Notification.find({
      _id: { $in: user.notifications }, // Filter notifications by those in the intended user's notifications array
      from: currentUserId, // Filter notifications by the sender
      type: type,
      responded: false,
    });

    if (notifications.length >= 1)
      return res.status(200).send("Request for intended user already sent");

    return res.status(404).send("Request for intended user not sent");
  }
);

// Get pending add as requests for a user
router.get("/requests", authMiddleware, async (req, res) => {
  const userId = req.user.id;
  const { type } = req.query;

  if (!userId || !type) return res.status(400).send("Bad request");

  try {
    const notifications = await Notification.find({
      to: userId, // Filter notifications by those in the intended user's notifications array
      type: type,
      responded: false,
    })
      .select("from")
      // .populate({
      //   path: "from",
      //   select: "_id firstName lastName",
      // })
      .sort({ timestamp: -1 });

    if (notifications.length === 0)
      return res.status(404).send("No pending supervisee requets");

    const formattedNotifications = [];
    for (const notification of notifications) {
      const civilian = await Civilian.findById(notification.from).select(
        "_id firstName lastName profilePic"
      );

      const firstResponder = await FirstResponder.findById(
        notification.from
      ).select("_id firstName lastName profilePic");
      const user = civilian || firstResponder;

      const formattedNotification = {
        _id: notification._id,
        from: {
          _id: user._id,
          firstName: user.firstName,
          lastName: user.lastName,
        },
      };

      formattedNotifications.push(formattedNotification);
    }
    return res.status(200).send(formattedNotifications);
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

// Change responded to true in a notification
router.patch("/responded/:notificationId", authMiddleware, async (req, res) => {
  const { notificationId } = req.params;

  if (!notificationId) return res.status(400).send("Bad Request");
  try {
    const updatedNotification = await Notification.findByIdAndUpdate(
      notificationId,
      { responded: true },
      { new: true }
    );

    if (!updatedNotification)
      return res.status(404).send("Notification with the given id not found");

    return res.status(200).send("Notification updated successfully");
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal server error");
  }
});

// send request notifications
router.post("/send", authMiddleware, async (req, res) => {
  const { error } = validate(req.body);
  if (error) return res.status(400).send(error.details[0].message);

  const { from, to, type, title, body } = req.body;
  let notification;

  // Save to db - notifications collection
  try {
    notification = new Notification({
      from: from,
      to: to,
      type: type,
      title: title,
      body: body,
      timestamp: new Date().toLocaleString(),
      responded: false,
    });

    await notification.save();
  } catch (error) {
    console.log("Error: ");
    res.status(500).send(error);
  }

  // Save to db - user notifications
  const [civilian, firstResponder] = await Promise.all([
    Civilian.findByIdAndUpdate(
      to,
      { $push: { notifications: notification._id } },
      { new: true }
    ),
    FirstResponder.findByIdAndUpdate(
      to,
      { $push: { notifications: notification._id } },
      { new: true }
    ),
  ]);

  let user = civilian || firstResponder;

  if (!user)
    return res.status(404).send("Receiver with the given id not found");

  // Send notification
  const { fcmToken } = await Civilian.findById(to).select("fcmToken"); // Add if not token logic
  if (!fcmToken) return res.status(404).send("Reciever FCM token not found");

  try {
    admin.messaging().send({
      token: fcmToken,
      notification: {
        title: title,
        body: body,
      },
    });
    console.log("Notification send successfully");
    res.status(200).send("Send Success");
  } catch (error) {
    console.error("Error: " + error);
    res.status(500).send("Internal Server Error");
  }
});

module.exports = router;
