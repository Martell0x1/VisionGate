import { Entity, PrimaryColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { User } from '../../user/entities/user.entity';
import { Plan } from '../../plan/entities/plan.entity';

@Entity('cars')
export class Car {
  @PrimaryColumn({ length: 6 })
  car_id: string; // license plate maybe?

  @Column({ length: 100 })
  company: string;

  @Column({ length: 100 })
  car_model: string;

  @Column({ type: 'timestamp', nullable: true })
  subscription_start: Date;

  @Column({ type: 'varchar', length: 100, nullable: false })
  license_plate: string;

  @ManyToOne(() => User, (user) => user.cars)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Plan, (plan) => plan.cars)
  @JoinColumn({ name: 'plan_id' })
  plan: Plan;
}
