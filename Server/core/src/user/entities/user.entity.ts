import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Car } from '../../car/entities/car.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('increment')
  user_id: number;

  @Column({ length: 100 })
  first_name: string;

  @Column({ length: 100 })
  last_name: string;

  @Column({ length: 100 })
  address: string;

  @Column({ length: 100 })
  phone: string;

  @Column({ type: 'date' })
  dob: Date;

  @Column({ unique: true, length: 100 })
  email: string;

  @Column({ length: 100 })
  NAID: string;

  // @Column({ length: 250, nullable: true })
  // image_link: string;

  @Column({ length: 250 })
  password: string;

  @OneToMany(() => Car, (car) => car.user_id)
  cars: Car[];
}
