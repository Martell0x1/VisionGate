import { CarsService } from 'src/car/car.service';
import { MlService } from 'src/ml/ml.service';
import { MqttService } from 'src/mqtt/mqtt.service';
export declare class espDetectionService {
    private readonly mlService;
    private readonly carService;
    private readonly mqttService;
    constructor(mlService: MlService, carService: CarsService, mqttService: MqttService);
    private readonly AllowedExts;
    processFile(file: Express.Multer.File): Promise<any>;
    getData(licensePlate: string): Promise<{
        user: import("../car/entities/car.entity").Car | null;
        car: import("../car/entities/car.entity").Car | null;
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
    notifyDetection(plate: string): Promise<void>;
}
