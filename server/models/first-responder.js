const mongoose = require("mongoose");
const Joi = require("joi");
const jwt = require("jsonwebtoken");
const { userSchema, userValidationSchema } = require("../common/sharedSchema");

const responderValues = ["Police", "Paramedic", "Fire"]; // Add more

const firstResponderSchema = new mongoose.Schema({
  ...userSchema.obj,
  type: { type: String, enum: responderValues, required: true },
  workId: { type: String, maxlength: 32, required: true },
  workAddress: {
    type: String,
    minlength: 5,
    maxlength: 255,
    required: true,
  },
  availability: {
    type: Boolean,
    default: false,
  },
  latitude: {
    type: Number,
  },
  longitude: {
    type: Number,
  },
  supervisorAccounts: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "FirstResponder",
      },
    ],
    default: [],
  },
  superviseeAccounts: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "FirstResponder",
      },
    ],
    default: [],
  },
  sosReports: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "SOSReport",
      },
    ],
    default: [],
  },
  incidentReports: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "IncidentReport",
      },
    ],
    default: [],
  },
});

firstResponderSchema.methods.generateAuthToken = function () {
  return jwt.sign(
    {
      userType: "first-responder",
      id: this._id,
      username: this.username,
      firstName: this.firstName,
    },
    "jwtPrivateKey" // Change this to config.get("jwtPrvateKey")
  );
};

firstResponderSchema.methods.generateIdToken = function () {
  return jwt.sign(
    {
      userType: "first-responder",
      id: this._id,
      username: this.username,
      firstName: this.firstName,
      lastName: this.lastName,
      nicNo: this.nicNo,
      phnNo: this.phoneNumber,
      email: this.email,
      profilePic: this.profilePic,
      type: this.type,
      workId: this.workId,
      workAddress: this.workAddress,
    },
    "jwtPrivateKey"
  );
};

const FirstResponder = mongoose.model("FirstResponder", firstResponderSchema);

function validateFirstResponder(user) {
  const firstResponderValidationSchema = userValidationSchema.keys({
    type: Joi.string()
      .valid(...responderValues)
      .required(),
    workId: Joi.string().max(32).required(),
    workAddress: Joi.string().min(5).max(255).required(),
  });
  return firstResponderValidationSchema.validate(user);
}

module.exports = { FirstResponder, validate: validateFirstResponder };
