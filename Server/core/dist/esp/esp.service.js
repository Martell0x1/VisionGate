"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.espDetectionService = void 0;
const common_1 = require("@nestjs/common");
const fs_1 = require("fs");
const path = __importStar(require("path"));
const car_service_1 = require("../car/car.service");
const ml_service_1 = require("../ml/ml.service");
let espDetectionService = class espDetectionService {
    mlService;
    carService;
    constructor(mlService, carService) {
        this.mlService = mlService;
        this.carService = carService;
    }
    AllowedExts = [
        '.apng',
        '.png',
        '.avif',
        '.gif',
        '.jpg',
        '.jpeg',
        '.jfif',
        '.pjpeg',
        '.pjp',
        '.svg',
        '.webp',
        '.bmp',
        '.ico',
        '.cur',
        '.tif',
        '.tiff',
    ];
    async processFile(file) {
        const data = await this.mlService.recognize(file);
        return data;
    }
    async getData(licensePlate) {
        const user = await this.carService.findUserByLicensePlate(licensePlate);
        const car = await this.carService.findCarWithLicensePlate(licensePlate);
        return { user, car };
    }
    async uploadFile(file) {
        if (!file) {
            return { status: 'error', message: 'No file uploaded' };
        }
        const ext = path.extname(file.originalname).toLowerCase();
        if (!this.AllowedExts.includes(ext)) {
            return { status: 'error', uploaded: false, message: 'Invalid file type' };
        }
        const uploadPath = path.join(__dirname, '../../', 'uploads');
        if (!(0, fs_1.existsSync)(uploadPath)) {
            (0, fs_1.mkdirSync)(uploadPath, { recursive: true });
        }
        const newFilename = `file${ext}`;
        const newPath = path.join(uploadPath, newFilename);
        return {
            status: 'Uploaded',
            uploaded: true,
            message: 'File uploaded',
            filename: newFilename,
        };
    }
};
exports.espDetectionService = espDetectionService;
exports.espDetectionService = espDetectionService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [ml_service_1.MlService,
        car_service_1.CarsService])
], espDetectionService);
//# sourceMappingURL=esp.service.js.map