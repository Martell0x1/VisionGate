import { espDetectionService } from './esp.service';
import { UploadFileEspDTO } from './dtos/UploadFileEspDTO';
export declare class espController {
    private readonly espService;
    constructor(espService: espDetectionService);
    uploadFile(file: Express.Multer.File, body: UploadFileEspDTO): Promise<any>;
}
