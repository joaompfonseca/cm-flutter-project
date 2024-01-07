const amplifyconfig = '''{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "eu-west-1_ABLidXpM0",
                        "AppClientId": "5h40q3f3o21g747smbu3hjmq0u",
                        "Region": "eu-west-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "USER_SRP_AUTH",
                        "socialProviders": [],
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "GIVEN_NAME",
                            "FAMILY_NAME",
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": [
                                "REQUIRES_LOWERCASE",
                                "REQUIRES_UPPERCASE",
                                "REQUIRES_NUMBERS",
                                "REQUIRES_SYMBOLS"
                            ]
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }
            }
        }
    }
}''';
