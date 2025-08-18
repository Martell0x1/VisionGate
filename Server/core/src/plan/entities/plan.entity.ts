import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Car } from '../../car/entities/car.entity';

@Entity('plans')
export class Plan {
  @PrimaryGeneratedColumn('increment')
  plan_id: number;

  @Column({ type: 'smallint' })
  value: number;

  @Column({ length: 50 })
  unit: string;

  @Column({ type: 'int' })
  price: number;

  @OneToMany(() => Car, (car) => car.plan)
  cars: Car[];
}
