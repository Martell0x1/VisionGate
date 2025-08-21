import { DataSource } from 'typeorm';
export declare class DatabaseConfigController {
    private readonly datasource;
    constructor(datasource: DataSource);
    healthCheck(): Promise<{
        status: string;
        db: string;
        message?: undefined;
    } | {
        status: string;
        db: string;
        message: any;
    }>;
}
