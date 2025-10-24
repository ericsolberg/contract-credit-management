namespace contract.management;

using { cuid, managed, temporal } from '@sap/cds/common';

entity Customers : cuid, managed {
  name                : String(100) not null;
  email              : String(100);
  phone              : String(20);
  address            : String(500);
  creditStatus       : String(20) enum { Approved; Pending; Rejected } default 'Pending';
  creditLimit        : Decimal(15,2) default 0;
  totalContractValue : Decimal(15,2) default 0;
  riskScore          : Integer default 0;
  creditCheckRequired : Boolean default true;
  
  // Associations
  contracts          : Composition of many ValueContracts on contracts.customer = $self;
}

entity ValueContracts : cuid, managed {
  contractNumber     : String(20) not null;
  customer           : Association to Customers not null;
  contractValue      : Decimal(15,2) not null;
  totalSpend         : Decimal(15,2) default 0;
  remainingValue     : Decimal(15,2);
  status             : String(20) enum { 
    Draft; 
    PendingApproval; 
    Active; 
    Completed; 
    Rejected 
  } default 'Draft';
  creditCheckRequired : Boolean default true;
  exclusionReason    : String(500);
  exclusionApprovedBy : String(100);
  startDate          : Date;
  endDate            : Date;
  
  // Associations
  events             : Composition of many ContractEvents on events.contract = $self;
  workflows          : Composition of many WorkflowInstances on workflows.contract = $self;
}

entity ContractEvents : cuid, managed {
  contract           : Association to ValueContracts not null;
  eventType          : String(30) enum { 
    Created; 
    ValueIncreased; 
    StatusChanged; 
    CreditCheckDecision;
    ApprovalCompleted 
  } not null;
  eventDate          : DateTime default $now;
  previousValue      : Decimal(15,2);
  newValue           : Decimal(15,2);
  statusChange       : String(50);
  triggeredProcessID : String(100);
  description        : String(500);
  
  // Associations
  workflows          : Composition of many WorkflowInstances on workflows.contractEvent = $self;
}

entity WorkflowInstances : cuid, managed {
  contract           : Association to ValueContracts not null;
  contractEvent      : Association to ContractEvents;
  processType        : String(30) enum { 
    CreditCheckDecision; 
    CreditAssessment; 
    EscalatedApproval 
  } not null;
  status             : String(20) enum { 
    Running; 
    Completed; 
    Failed; 
    Cancelled 
  } default 'Running';
  processInstanceID  : String(100);
  startedDate        : DateTime default $now;
  completedDate      : DateTime;
  errorMessage       : String(500);
  processData        : String(2000); // JSON data for process context
}

// Views for reporting and analytics
view CustomerSummary as select from Customers {
  ID,
  name,
  creditStatus,
  creditLimit,
  totalContractValue,
  riskScore,
  contracts.contractValue as activeContractValue : Decimal(15,2)
} where contracts.status = 'Active';

view ContractSummary as select from ValueContracts {
  ID,
  contractNumber,
  customer.name as customerName : String(100),
  contractValue,
  totalSpend,
  remainingValue,
  status,
  creditCheckRequired,
  startDate,
  endDate
};