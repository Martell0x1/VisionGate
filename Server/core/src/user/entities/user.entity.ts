import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class UserEntity {
  @PrimaryGeneratedColumn()
  id: string;

  @Column('varchar')
  first_name: string;

  @Column('varchar')
  last_name: string;

  @Column('varchar')
  email: string;

  @Column('varchar')
  password: string;

  @Column('date')
  DOF: Date;

  @Column('varchar')
  address: string;

  @Column('varchar')
  phone: string;
}
