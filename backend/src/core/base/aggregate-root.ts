import { Entity } from './entity';

export abstract class AggregateRoot<T> extends Entity<T> {
  // Domain events can be handled here if you need to add them later.
}
