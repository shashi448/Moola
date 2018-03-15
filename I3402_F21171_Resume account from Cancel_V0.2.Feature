# Project: Universe 2.0 - Postpaid
# Test Release: Demo 13
# Test Cycle: SIT-IPT Testing
#
# References:
# Initiative: I3402 - Resume from Cancel
# Features: F21171_Resume account from Cancel
# Description: As a permissioned Rep, I would like to Resume cancelled lines from the customer's account
# QC Test Case IDs: Not Applicable
# Use Cases: Not Applicable
#
# Author Name: Kalyani Vemparala
# Author Email ID: Kalyani.Vemparala1@t-mobile.com
# Date: 3/12/2018
# Version: 0.2
#
# Peer Review:
# Lead Review: Nikita.Luhadia@t-mobile.com
#
# ARD References: U2_PP_F21171_Resume account from Cancel
#
Feature: As a Permissioned Rep, I would like to resume Cancelled FAN/Lines from the customer's account
   As an assisted Rep
   I want to be able to resume the cancelled lines from the customer's account

  @U2_Postpaid @Resume_AccountFromCancel_ML
  Scenario Outline: Rep performs resume for the cancelled FAN/Line in the customer's account
    Given Rep has logged into SAP CARE UI with Profile "<Profile_Type>"
    And Rep has looked up postpaid customer "<MSISDN>"
    And customer should have "<Pre-conditions>"
    And Rep has verified the customer with PIN
    And Rep has navigated to the FAN overview page
    And Rep navigates to LOS Page
    And the line cancelled date is not before 90 days
    And Rep clicks on Resume from cancel CTA
    And Rep verifies "<SIM_Eligiblity>" for the resume
    And Rep verifies "<MSISDN_Eligiblity>" for the resume
    And Rep continues with Exiting Plan & Services in the cancelled account
    And selects "<Reason>" for the resume account from the cancellation
    And selects "<Resume_Date>" from the calender
    And navigates to Review cart Page
    And proceeds to Payment info & Submit page
    And Rep verifies terms and conditions
    And Rep checks the consent
    Then Rep should be able to submit the Order
    And the Order confirmation page should be displayed
    And Rep will see "MSISDN_Resumed", "SIM_Change_Indicator", "MRCs" details in the order confirmation page
    And Order status should be completed
	And The resumed line/FAN status on UI should be active
	And BSCS DB should be updated with the resumed lines in the account
    And OM DB should be updated with the resumed lines in the account
    And SAMSON DB should be updated with the resumed lines with MSISDNs/SIMs status_Applicable if SIM/MSISDN got changed while doing the resume line

    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | Profile_Type | MSISDN     | Pre-conditions                                          | SIM_Eligiblity                                          | MSISDN_Eligibility                                                                          | Reason          | Resume_Date                                    |
      |            | Rep Care     | 5412929024 | ML Cancelled account with All lines in cancelled status | SIM is not eligible for resume, continue with new SIM   | MSISDN is eligible for resume but Rep wants to continue with new MSISDN instead of existing | Military Resume | Mid of the Bill cycle of cancelled account     |
      |            | Rep Care     | 5412929024 | ML Cancelled account with one line in cancelled status  | SIM is eligible for resume, continue with Old SIM       | MSISDN is eligible for resume, Rep wants to continue with Old MSISDN                        | Buyers Remorse  | Mid of the Bill cycle of cancelled account     |
      |            | Rep Care     | 5412929024 | ML Cancelled account with one line in cancelled status  | SIM is eligible for resume, continue with Old SIM       | MSISDN is eligible for resume but Rep wants to continue with new MSISDN instead of existing | Military Resume | Outside of the Bill cycle of cancelled account |
      |            | Rep Care     | 5412929024 | SL cancelled account                                    | SIM is eligible for resume, continue with Old SIM       | MSISDN is eligible for resume, Rep wants to continue with Old MSISDN                        | Buyers Remorse  | Outside of the Bill cycle of cancelled account |

  @U2_Postpaid @Resume_AccountFromCancel_FraudLockON
  Scenario Outline: Rep performs resume for the cancelled FAN/Line in the customer's account with Fraud ON
    Given Rep has logged into SAP CARE UI with Profile "<Profile_Type>"
    And Rep has looked up postpaid customer "<MSISDN>"
    And customer should have "<Pre-conditions>"
    And Rep has verified the customer with PIN
    And Rep has navigated to the FAN overview page
    And Rep has navigated to LOS page of Fraud MSISDN
    Then the lines with Fraud lock ON should not be allowed to resume from the cancellation

    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | Profile_Type | MSISDN     | Pre-conditions                                                                                |
      |            | Rep Care     | 5412929024 | ML Account with 2 cancelled lines, One line with Fraud lock ON & Other is with Fraud lock OFF |

  @U2_Postpaid @Resume_AccountFromCancel_FraudRepProfile_UpdateBillingaddress
  Scenario Outline: Rep performs resume for the cancelled FAN/Line in the customer's account with Fraud Rep Profile
    Given Rep has logged into SAP CARE UI with Profile "<Profile_Type>"
    And Rep has looked up postpaid customer "<MSISDN>"
    And Rep has verified the customer with PIN
    And Rep has navigated to the FAN overview page
    And the FAN is with Fraud lock ON
    And the account cancelled date is not before 90 days
    And Rep clicks on Resume from cancel CTA
    And Rep verifies "<Billing_Address_Popup>" for the resume
    And Rep updates new "<New_Billing_Address>" with the required details
    And Rep continues with Exiting Plan & Services in the cancelled account
    And selects "<Reason>" for the resume account from the cancellation
    And selects "<Resume_Date>" from the calender
    And navigates to Review cart Page
    And proceeds to Payment info & Submit page
    And Rep verifies terms and conditions
    And Rep checks the consent
    Then Rep should be able to submit the Order
    And the Order confirmation page should be displayed
    And Rep will see "MSISDN_Resumed", "SIM_Change_Indicator", "MRCs" details in the order confirmation page
    And The resumed line should be active in the account
    And Order status should be completed
    And BSCS DB should be updated with the resumed lines in the account
    And OM DB should be updated with the resumed lines in the account
    And Verify UI for the resumed line/FAN status changed to Active
	And Billing address should be updated in UI when Rep changes the billing address during resume

    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | Profile_Type | MSISDN     | Billing_Address_Popup  | New_Billing_Address                           | Reason          | Resume_Date |
      |            | Rep Care     | 5412929024 | Rep selects Yes option | 2 Ravinia Dr, Atlanta,GA,30346                | Military Resume | Same Day    |
      |            | Rep Care     | 5412929024 | Rep selects NO option  | None, Continues with Existing billing address | Military Resume | Same Day    |
