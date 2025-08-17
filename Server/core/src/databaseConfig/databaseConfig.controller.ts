import { Controller, Get } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Controller('databaseConfig')
export class DatabaseConfigController {
  constructor(private readonly datasource: DataSource) {}

  @Get('health')
  async healthCheck() {
    if (!this.datasource.isInitialized) {
      return { status: 'error', db: 'not connected !' };
    }
    try {
      await this.datasource.query('SELECT 1');
      return { status: 'ok', db: 'connected !' };
    } catch (e) {
      return { status: 'error', db: 'not connected !', message: e.message };
    }
  }
}
