const mongoose = require("mongoose");
const Joi = require("joi");
Joi.objectId = require("joi-objectid")(Joi);

const incidentReportSchema = new mongoose.Schema({
  victimId: { type: mongoose.Schema.Types.ObjectId, required: true },
  location: { type: String },
  image: { type: String, maxlength: 1024 },
  voice: { type: String },
  description: { type: String, maxlength: 9048 },
  timeStamp: { type: Date, default: Date.now() },
  directedTo: {
    type: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "FirstResponder",
      },
    ],
    default: [],
  },
});

const IncidentReport = mongoose.model("IncidentReport", incidentReportSchema);

function validateIncidentReport(incidentReport) {
  const schema = Joi.object({
    victimId: Joi.objectId().required(),
    location: Joi.string().allow(""),
    image: Joi.string().max(1024).allow(""),
    voice: Joi.string().allow(""),
    description: Joi.string().max(9048).allow(""),
    timeStamp: Joi.date(),
  });

  return schema.validate(incidentReport);
}

module.exports = { IncidentReport, validate: validateIncidentReport };
