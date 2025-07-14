import { randomUUID } from "crypto"; // Native Node.js module for UUIDs
import { AggregateRoot, DomainAuditProps } from "../../base";
import { StatusEnum } from "../enums";

export interface UserProps extends DomainAuditProps {
  userId: string;
  name: string;
  lastName: string;
  identityDocument: string;
  cityId: string;
  address: string;

  phone: string;
  email: string;
  userName: string;
  passwordHash: string; // Important: The domain does not handle plain text passwords.
  statusId: number;
}

export class User extends AggregateRoot<UserProps> {
  private readonly _userId: string;
  private _name: string;
  private _lastName: string;
  private _identityDocument: string;
  private _cityId: string;
  private _address: string;
  private _phone: string;
  private _email: string;
  private _userName: string;
  private _passwordHash: string;
  private _statusId: number;
  private readonly _createdAt?: Date;
  private _modifiedAt?: Date;
  private readonly _createdBy?: string;
  private _modifiedBy?: string;

  private constructor(props: UserProps, id?: string) {
    super(props, id);
    this._userId = props.userId;
    this._name = props.name;
    this._lastName = props.lastName;
    this._identityDocument = props.identityDocument;
    this._cityId = props.cityId;
    this._address = props.address;
    this._phone = props.phone;
    this._email = props.email;
    this._userName = props.userName;
    this._passwordHash = props.passwordHash;
    this._statusId = props.statusId;
    this._createdAt = props.createdAt;
    this._modifiedAt = props.modifiedAt;
    this._createdBy = props.createdBy;
    this._modifiedBy = props.modifiedBy;
  }

  public static create(
    data: Omit<UserProps, "userId" | "createdAt" | "statusId">
  ): User {
    if (
      !data.name ||
      data.name.trim().length < 2 ||
      data.name.trim().length > 100
    )
      throw new Error("User name must be between 2 and 100 characters.");

    if (
      !data.lastName ||
      data.lastName.trim().length < 2 ||
      data.lastName.trim().length > 100
    )
      throw new Error("User last name must be between 2 and 100 characters.");
      
    if (!data.identityDocument || data.identityDocument.trim().length === 0)
      throw new Error("Identity document is required.");
    
    if (data.identityDocument.trim().length > 50)
      throw new Error("Identity document cannot exceed 50 characters.");
    
    if (
      !data.email ||
      !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email) ||
      data.email.length > 125
    )
      throw new Error("Invalid email format or length exceeds 125 characters.");
      
    if (
      !data.userName ||
      data.userName.trim().length < 3 ||
      data.userName.trim().length > 100
    )
      throw new Error("Username must be between 3 and 100 characters.");
      
    if (/\s/.test(data.userName))
      throw new Error("Username cannot contain whitespace.");
    
    if (!data.passwordHash || data.passwordHash.trim().length === 0)
      throw new Error("Password hash is required.");
    
    if (
      !data.phone ||
      data.phone.trim().length < 7 ||
      data.phone.trim().length > 14
    )
      throw new Error("Phone number must be between 7 and 14 digits.");
    
    if (!/^[0-9+()-]+$/.test(data.phone))
      throw new Error("Phone number contains invalid characters.");
    
    if (!data.cityId || data.cityId.trim().length === 0)
      throw new Error("City ID is required.");
    
    if (!data.address || data.address.trim().length < 5)
      throw new Error("Address must be at least 5 characters long.");

    const userProps: UserProps = {
      ...data,
      userId: randomUUID(),
      statusId: StatusEnum.Active.value,
    };

    const user = new User(userProps);
    return user;
  }
  
  public static hydrate(props: UserProps): User {
    return new User(props);
  }
  
  public updateProfile(
    data: {
      name: string;
      lastName: string;
      address: string;
      phone: string;
    },
    modifierId: string
  ): void {
    this._name = data.name;
    this._lastName = data.lastName;
    this._address = data.address;
    this._phone = data.phone;
    this._modifiedAt = new Date();
    this._modifiedBy = modifierId;
  }

  public changePassword(newPasswordHash: string): void {
    if (newPasswordHash.length === 0) {
      throw new Error("Password hash cannot be empty.");
    }
    this._passwordHash = newPasswordHash;
  }

  public deactivate(): void {
    if (this._statusId === StatusEnum.Inactive.value)
      throw new Error("User is already inactive.");

    this._statusId = StatusEnum.Active.value;
  }

  public activate(): void {
    if (this._statusId === StatusEnum.Inactive.value)
      throw new Error("User is already active.");

    this._statusId = StatusEnum.Inactive.value;
  }

  // --- Getters:
  get userId(): string {
    return this._userId;
  }
  get name(): string {
    return this._name;
  }
  get lastName(): string {
    return this._lastName;
  }
  get identityDocument(): string {
    return this._identityDocument;
  }
  get cityId(): string {
    return this._cityId;
  }
  get address(): string {
    return this._address;
  }
  get phone(): string {
    return this._phone;
  }
  get email(): string {
    return this._email;
  }
  get userName(): string {
    return this._userName;
  }
  get passwordHash(): string {
    return this._passwordHash;
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
