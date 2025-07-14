export type DomainAuditProps = {
  // They are optional in the domain because their assignment is a responsibility of the Infrastructure layer when persisting.
  createdAt?: Date;
  createdBy?: string;
  modifiedAt?: Date;
  modifiedBy?: string;
};