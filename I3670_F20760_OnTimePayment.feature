# Project: Universe 2.0 - Postpaid
# Test Release: Demo-12 (Postpaid)
# Test Cycle: SIT-IPT Testing
#
# References
# Initiative:I3670 -Kickback and Autopay
# Feature: F20760 - On Time Payment clear change
# Description: Rep should be able to pay the Invoice on time and get kickback discount
# Use Cases: Not Applicable
#
# Author Name: Mani S
# Author Email ID: Mani.S2@T-mobile.com
# Date: 03/09/2018
# Version: 0.4
#
# Peer Review: thulasiram.vakkakula@t-mobile.com
# Lead Review: 
Feature: On Time Payment clear change
  
  			 As a Customer 
  			 I want to pay the Invoice/Bill on time 
  			 So that i get the kickback discounts on my bill

  @VerifyAutopayDiscountsOnBill_TestIdFromQC
  Scenario Outline: Verify the autopay discounts applied on the firstbill
    Given Rep has logged into SAP CARE
    And Rep has created an account successfully
    And Rep has looked up for postpaid customer using "<FAN>"
    And Rep has verifed the customer with PIN
    And Rep has navigated to the FAN Overview Page
    And Fraud Lock Indicator is not enabled
    And Rep selects the "Autopay" link
    And Rep navigates to "Enroll for Autopay" page
    And Rep selects the "Payment Type"
    And "First","Last" name is prepopulated
    And Rep enters "<Card number>","<Expiry date>" "<CVV>"
    And Rep enters the "Card Details Address"
    And Rep validates the "Address"
    And Rep accepts the "Customer Consent"
    When Rep submits the "Order"
    Then Order confirmtion page should be displayed with "Order ID"
    And Rep verifies Autopay enrollment Updates in UI
    And "Autopay" hyperlink is updated to ON from OFF
    And "BSCS" DB is updated with the autopay enrollment

    #And Rep performs the first "Bill Cycle" run successfully
    #And Rep navigates to "Billed Summary"
    #And Rep verifies "Autopay Discounts" is applied to FANs and Lines
    #And "Autopay" discounts is applied in first month bill
    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | FAN       | Card Number     | Expiry Date | CVV |
      |      36516 | 194030036 | 348414271412722 | 06/19       | 366 |

  @On-TimePaymentAttribute_TestIdFromQC
  Scenario Outline: Verify the 'on-time' attribute is set to 'NULL' after Payment Reversal
    Given Rep has logged into SAP CARE
    #Rep Has looked up with customer whose invoice balance open balance greater than 0
    And Rep has looked up for postpaid customer using "<FAN>"
    And Rep has verifed the customer with PIN
    And Rep has navigated to the FAN Overview Page
    And Fraud Lock Indicator is not enabled
    And Rep performs "One-Time" payment
    And "Invoice balance" should be updated to zero
    And Rep verifies "on-time payment" attribute is set to "G" at the backend
    And Rep navigates to "Pending Charges and Credit" section in "Billing" tab
    And Rep selects the "One time" payment charges from the List
    When Rep selects the "Reverse Charge" option
    And Rep performs "Payment Reversal" for the selected charge successfully
    Then "On-Time Payment" attribute should be set to NULL at the Backend
    And verify the values in "BSCS" DB

    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | FAN       |
      |      36518 | 194029846 |

  @On-Time_PaymentAttribute_TestIdFromQC
  Scenario Outline: Verify the 'on-time' attribute is set to 'G' after the Bill Credit
    Given Rep has logged into SAP CARE
    #Rep Has looked up with customer whose invoice balance open balance greater than 0
    And Rep has looked up for postpaid customer using "<FAN>"
    And Rep has verifed the customer with PIN
    And Rep has navigated to the FAN Overview Page
    And Fraud Lock Indicator is not enabled
    When Rep performs "Bill Credit" as per customer request
    Then "Invoice" open amount is updated to zero
    And Rep verifies that "On-time payment" attribute is set to 'G' at the Backend
    And verify the values in "BSCS" DB

    @KBS @ExtendedRegression
    Examples: 
      | QC_Test_Id | FAN       |
      |      36519 | 194029846 |

  @On-TimePaymentAttribute_TestIdFromQC
  Scenario Outline: Verify the status of Payment attribute for Partial Payment done for Invoice
    Given Rep has logged into SAP CARE
    And Rep has created an account successfully
    And Rep performs the first "Bill Cycle" run successfully
    #Rep Has looked up with customer whose invoice balance open balance greater than 0
    And "On-Time Payment" attribute is set to NULL
    And Rep has looked up for postpaid customer using "<FAN>"
    And Rep has verifed the customer with PIN
    And Rep has navigated to the FAN Overview Page
    And Fraud Lock Indicator is not enabled
    When Rep performs "Partial" payment
    Then "On-Time Payment" attribute should be set to "NULL" at the Backend
    And Rep verifies the status remains "NULL" unless the "INVOICE" is fully paid
    And verify the values in "BSCS" DB

    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | FAN       |
      |      36513 | 194029846 |

  @On-TimePaymentAttribute_TestIdFromQC
  Scenario Outline: Verify the status of Payment attribute when customer has passed the due Date
    Given Rep has logged into SAP CARE
    And Rep has created an account successfully
    And Rep performs the first "Bill Cycle" run successfully
    #Rep Has looked up with customer whose invoice balance open balance greater than 0
    And "On-Time Payment" attribute is set to NULL at the Backend
    And Rep has looked up for postpaid customer using "<FAN>"
    And Rep has verifed the customer with PIN
    And Rep has navigated to the FAN Overview Page
    And Fraud Lock Indicator is not enabled
    And Rep verifies "Customer" has passed the "Due Date"
    And Verifies the customer is "<Grace_Period>"
    When Rep performs "Full Payment"
    Then the status of "On-Time" payment attribute should be set to "B"
    And status indicates the Customer has not paid the bill before the "Due date"

    @KBS @ExtendedRegression
    Examples: 
      | QC_Test_Id | FAN       | Grace_Period |
      |      36515 | 194020036 | Within Grace |
      |      36521 | 194029846 | out of Grace |
      |      36517 | 194020036 | Within Grace |

  @On-Time_PaymentAttribute_TestIdFromQC
  Scenario Outline: Verify the 'on-time' attribute is set to 'G' after the Full Payment within Grace Period
    Given Rep has logged into SAP CARE
    And Rep has created an account successfully
    And Rep performs the first "Bill Cycle" run successfully
    #Rep Has looked up with customer whose invoice balance open balance greater than 0
    And "On-Time Payment" attribute is set to NULL at the Backend
    And Rep has looked up for postpaid customer using "<FAN>"
    And Rep has verifed the customer with PIN
    And Rep has navigated to the FAN Overview Page
    And Fraud Lock Indicator is not enabled
    And Rep verifies "Customer" is well within the "Due Date"
    When Rep performs "Full Payment"
    Then "On-time payment" attribute should be set to "G"
    And Customer enrolls in "Autopay"

    #And Rep performs the first "Bill Cycle" run successfully
    #And Rep navigates to "Billed Summary"
    #And Rep verifies "Autopay Discounts" is applied to FANs and Lines
    #And "Autopay" discounts is applied in next month bill
    @KBS @CoreRegression
    Examples: 
      | QC_Test_Id | FAN       |
      |      36514 | 194029846 |
