___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "GA4 Client \u0026 Session Parser",
  "description": "GA4 Client \u0026 Session Parser extracts key data (client ID, session ID, session number) from readAnalyticsStorage sandbox API for use in Google Tag Manager tags and variables.\n\nDeveloped by: Utku Gülden",
  "categories": [
    "ANALYTICS"
  ],
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "measurement_id",
    "displayName": "Measurement ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^G-[A-Za-z0-9]{10,}$"
        ]
      },
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Input a valid GA4 Measurement ID."
  },
  {
    "type": "SELECT",
    "name": "parameter",
    "displayName": "Parameters",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "client_id",
        "displayValue": "Client ID"
      },
      {
        "value": "session_id",
        "displayValue": "Session ID"
      },
      {
        "value": "session_number",
        "displayValue": "Session Number"
      }
    ],
    "simpleValueType": true,
    "help": "Select the desired parameter to retrieve."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const readAnalyticsStorage = require('readAnalyticsStorage');
const getType = require('getType');
const templateStorage = require('templateStorage');

const param = data.parameter;
const measurementId = data.measurement_id;

const stored = templateStorage.getItem('ga4_session_values');
let output;

if (stored && stored.measurement_id === measurementId) {
  if (param === 'client_id') {
    output = stored.client_id;
  } else if (param === 'session_id') {
    output = stored.session_id;
  } else if (param === 'session_number') {
    output = stored.session_number;
  } else if (param === 'measurement_id') {
    output = stored.measurement_id;
  }
} else {
  const analytics = readAnalyticsStorage();

  if (
    analytics &&
    getType(analytics.sessions) === 'array' &&
    analytics.sessions.length > 0 &&
    typeof measurementId === 'string' &&
    measurementId.length > 0
  ) {
    for (let i = 0; i < analytics.sessions.length; i++) {
      const session = analytics.sessions[i];

      if (session.measurement_id === measurementId) {
        const sessionData = {
          client_id: analytics.client_id,
          session_id: session.session_id,
          session_number: session.session_number,
          measurement_id: session.measurement_id
        };

        templateStorage.setItem('ga4_session_values', sessionData);

        if (param === 'client_id') {
          output = sessionData.client_id;
        } else if (param === 'session_id') {
          output = sessionData.session_id;
        } else if (param === 'session_number') {
          output = sessionData.session_number;
        } else if (param === 'measurement_id') {
          output = sessionData.measurement_id;
        }

        break;
      }
    }
  }
}

return output;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_analytics_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_template_storage",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 8/2/2025, 9:54:52 AM


