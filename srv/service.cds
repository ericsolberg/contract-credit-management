using { contract.management as cm } from '../db/schema';

namespace contract.management.service;

@path: '/contract-management'
service ContractManagementService {
  
  // Customer Management
  @cds.redirection.target
  entity Customers as projection on cm.Customers;
  
  // Contract Management  
  @odata.draft.enabled
  @cds.redirection.target
  entity ValueContracts as projection on cm.ValueContracts {
    *,
    customer.name as customerName : String(100),
    customer.creditStatus as customerCreditStatus : String(20)
  } actions {
    action submitForApproval() returns String;
    action approve(reason: String) returns String;
    action reject(reason: String) returns String;
    action excludeFromCreditCheck(reason: String) returns String;
  };
  
  // Contract Events (Read-only for audit trail)
  @readonly
  entity ContractEvents as projection on cm.ContractEvents {
    *,
    contract.contractNumber as contractNumber : String(20),
    contract.customer.name as customerName : String(100)
  };
  
  // Workflow Monitoring (Read-only)
  @readonly  
  entity WorkflowInstances as projection on cm.WorkflowInstances {
    *,
    contract.contractNumber as contractNumber : String(20),
    contract.customer.name as customerName : String(100)
  };
  
  // Analytics Views
  @readonly
  entity CustomerSummary as projection on cm.CustomerSummary;
  
  @readonly
  entity ContractSummary as projection on cm.ContractSummary;
  
  // Unbound Actions for Process Integration
  action triggerCreditCheckDecision(contractID: UUID) returns String;
  action triggerCreditAssessment(contractID: UUID) returns String;
  action triggerEscalatedApproval(contractID: UUID, reason: String) returns String;
  
  // Utility Functions
  function getContractsByStatus(status: String) returns array of ValueContracts;
  function getCustomerRiskProfile(customerID: UUID) returns {
    riskScore: Integer;
    creditStatus: String;
    totalExposure: Decimal;
    recommendations: array of String;
  };
  
  // Events for Process Automation Integration
  event ContractCreated {
    contractID: UUID;
    customerID: UUID;
    contractValue: Decimal;
    creditCheckRequired: Boolean;
  }
  
  event ContractValueIncreased {
    contractID: UUID;
    customerID: UUID;
    previousValue: Decimal;
    newValue: Decimal;
  }
  
  event CreditCheckDecisionCompleted {
    contractID: UUID;
    decision: String; // Include or Exclude
    processInstanceID: String;
  }
  
  event EscalatedApprovalCompleted {
    contractID: UUID;
    approved: Boolean;
    approvedBy: String;
    reason: String;
  }
}

// Separate service for external process automation integration
@path: '/process-integration'
service ProcessIntegrationService {
  
  // Webhook endpoints for process callbacks
  action contractCreditCheckDecisionCallback(
    contractID: UUID,
    decision: String,
    processInstanceID: String,
    metadata: String
  ) returns String;
  
  action creditAssessmentCallback(
    contractID: UUID,
    riskScore: Integer,
    creditStatus: String,
    processInstanceID: String,
    assessmentData: String
  ) returns String;
  
  action escalatedApprovalCallback(
    contractID: UUID,
    approved: Boolean,
    approvedBy: String,
    reason: String,
    processInstanceID: String
  ) returns String;
  
  // Data access for processes
  function getContractForProcess(contractID: UUID) returns {
    ID: UUID;
    contractNumber: String;
    customerName: String;
    contractValue: Decimal;
    creditCheckRequired: Boolean;
    status: String;
  };
  
  function getCustomerForProcess(customerID: UUID) returns {
    ID: UUID;
    name: String;
    creditStatus: String;
    creditLimit: Decimal;
    riskScore: Integer;
  };
}