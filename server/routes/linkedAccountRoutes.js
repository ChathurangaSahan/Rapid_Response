const express = require("express");
const router = express.Router();
const { Civilian } = require("../models/civilian");

// Get the list of emergency contacts of a particular user
router.get("/emergency-contacts/:userId", async (req, res) => {
  const { userId } = req.params;
  if (!userId) return res.status(400).send("Bad request");

  try {
    const { emergencyContacts } = await Civilian.findById(userId)
      .select("emergencyContacts")
      .populate({
        path: "emergencyContacts",
        select: "firstName lastName phoneNumber email",
      });

    if (!emergencyContacts || emergencyContacts.length === 0)
      return res.status(404).send("No emergency contacts");

    return res.status(200).send(emergencyContacts);
  } catch (error) {
    console.log("Error: " + error);
    return res.status(500).send("Internal Server Error");
  }
});

// Check if the inteded user is already an emergency contact
router.get(
  "/emergency-contacts/:currentUserId/:intendedUserId",
  async (req, res) => {
    const { currentUserId, intendedUserId } = req.params;

    if (!currentUserId || !intendedUserId)
      return res.status(400).send("Missing parameter/s");

    const currentUser = await Civilian.findById(currentUserId).select(
      "emergencyContacts"
    );

    if (!currentUser)
      return res.status(400).send("User with given id not found");

    const isEmergencyContact =
      currentUser.emergencyContacts.includes(intendedUserId);

    return isEmergencyContact
      ? res.status(200).send("Intended user is already an emergency contact")
      : res.status(404).send("Intended user is not an emergency contact");
  }
);

module.exports = router;
