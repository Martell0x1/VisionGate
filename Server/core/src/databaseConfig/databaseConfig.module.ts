import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get<string>('DB_HOST'),
        port: configService.get<number>('DB_PORT'),
        username: configService.get<string>('DB_USER'),
        password: configService.get<string>('DB_PASS'),
        database: configService.get<string>('DB_NAME'),
        // ssl: configService.get<boolean>('DB_SSL')
        //   ? { rejectUnauthorized: false }
        //   : false,
        autoLoadEntities: true,
        synchronize: true, // Set to false in production
        entities: [__dirname + '/../**/*.entity{.ts,.js}'], // both production(js) and dev(ts)
      }),
    }),
  ],
})
export class DatabaseConfigModule {}
