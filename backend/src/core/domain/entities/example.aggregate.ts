// File: example.aggregate.ts

import { randomUUID } from "crypto"; // Native Node.js module for generating UUIDs.
import { AggregateRoot, DomainAuditProps } from "../../base"; // Import the domain base class.
import { StatusEnum } from "../enums"; // Enum of states, typically Active/Inactive.

/*
 ** Interface that defines the properties needed to build an Example Entity. 
 ** Includes audit properties inherited from DomainAuditProps. 
*/
export interface ExampleProps extends DomainAuditProps {
  exampleId: string;
  title: string;
  description: string;
  value: number;
  category: string;
  statusId: number;
}

/**
* Aggregate Root: Main domain class that encapsulates business rules and consistency.
* It is immutable from the outside and can only be constructed through static methods (create/hydrate).
*/
export class ExampleEntity extends AggregateRoot<ExampleProps> {
  // --- Propiedades privadas encapsuladas
  private readonly _exampleId: string;
  private _title: string;
  private _description: string;
  private _value: number;
  private _category: string;
  private _statusId: number;

  // --- Audit Properties
  private readonly _createdAt?: Date;
  private _modifiedAt?: Date;
  private readonly _createdBy?: string;
  private _modifiedBy?: string;

  /**
   * Private constructor: Only called from the create or hydrate methods.
   */
  private constructor(props: ExampleProps, id?: string) {
    super(props, id);

    this._exampleId = props.exampleId;
    this._title = props.title;
    this._description = props.description;
    this._value = props.value;
    this._category = props.category;
    this._statusId = props.statusId;

    this._createdAt = props.createdAt;
    this._modifiedAt = props.modifiedAt;
    this._createdBy = props.createdBy;
    this._modifiedBy = props.modifiedBy;
  }

  /**
  * Factory method: Creates a new Aggregate instance.
  * Performs domain validations and ensures data consistency.
  */
  public static create(data: Omit<ExampleProps, "exampleId" | "statusId">): ExampleEntity {
    if (!data.title || data.title.trim().length < 3 || data.title.length > 100)
      throw new Error("Title must be between 3 and 100 characters.");

    if (!data.category || data.category.trim().length === 0)
      throw new Error("Category is required.");

    if (data.value < 0)
      throw new Error("Value cannot be negative.");

    const props: ExampleProps = {
      ...data,
      exampleId: randomUUID(),
      statusId: StatusEnum.Active.value,
    };

    return new ExampleEntity(props);
  }

  /**
  * Method for reconstructing an instance from persisted data.
  * Primarily used in queries or mappings from the database.
  */
  public static hydrate(props: ExampleProps): ExampleEntity {
    return new ExampleEntity(props);
  }

  /**
  * Domain method to update core values.
  * Requires the modifier ID for auditing purposes.
  */
  public updateDetails(
    data: { title: string; description: string; value: number; category: string },
    modifierId: string
  ): void {
    if (!data.title || data.title.trim().length < 3)
      throw new Error("Title is too short.");

    this._title = data.title;
    this._description = data.description;
    this._value = data.value;
    this._category = data.category;
    this._modifiedAt = new Date();
    this._modifiedBy = modifierId;
  }

  /**
   * Changes status to inactive.
   */
  public deactivate(): void {
    if (this._statusId === StatusEnum.Inactive.value)
      throw new Error("Entity is already inactive.");

    this._statusId = StatusEnum.Inactive.value;
  }

  /**
   * Changes the status to active.
   */
  public activate(): void {
    if (this._statusId === StatusEnum.Active.value)
      throw new Error("Entity is already active.");

    this._statusId = StatusEnum.Active.value;
  }

  // --- Public getters: we access immutable properties from outside the domain
  get exampleId(): string {
    return this._exampleId;
  }

  get title(): string {
    return this._title;
  }

  get description(): string {
    return this._description;
  }

  get value(): number {
    return this._value;
  }

  get category(): string {
    return this._category;
  }

  get statusId(): number {
    return this._statusId;
  }

  get createdAt(): Date | undefined {
    return this._createdAt;
  }

  get modifiedAt(): Date | undefined {
    return this._modifiedAt;
  }

  get createdBy(): string | undefined {
    return this._createdBy;
  }

  get modifiedBy(): string | undefined {
    return this._modifiedBy;
  }
}
