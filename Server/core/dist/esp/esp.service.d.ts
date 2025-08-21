import { CarsService } from 'src/car/car.service';
import { MlService } from 'src/ml/ml.service';
export declare class espDetectionService {
    private readonly mlService;
    private readonly carService;
    constructor(mlService: MlService, carService: CarsService);
    private readonly AllowedExts;
    processFile(file: Express.Multer.File): Promise<any>;
    getData(licensePlate: string): Promise<{
        user: import("../user/entities/user.entity").User;
        car: import("../car/entities/car.entity").Car;
    }>;
    uploadFile(file: Express.Multer.File): Promise<{
        status: string;
        message: string;
        uploaded?: undefined;
        filename?: undefined;
    } | {
        status: string;
        uploaded: boolean;
        message: string;
        filename?: undefined;
    } | {
        status: string;
        uploaded: boolean;
        message: string;
        filename: string;
    }>;
}
