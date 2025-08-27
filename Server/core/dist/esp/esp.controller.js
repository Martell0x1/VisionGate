"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.espController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const esp_service_1 = require("./esp.service");
const UploadFileEspDTO_1 = require("./dtos/UploadFileEspDTO");
let espController = class espController {
    espService;
    constructor(espService) {
        this.espService = espService;
    }
    async uploadFile(file, body) {
        console.log('controller');
        const { uploaded } = await this.espService.uploadFile(file);
        if (!uploaded) {
            throw new common_1.HttpException('File upload failed', common_1.HttpStatus.BAD_REQUEST);
        }
        const data = await this.espService.processFile(file);
        const result = await this.espService.getData(data.licensePlate);
        console.log(result.car);
        if (result.car) {
            await this.espService.notifyDetection(data.licensePlate);
            return result.car;
        }
        else {
            return 'No car found';
        }
    }
};
exports.espController = espController;
__decorate([
    (0, common_1.Post)('detect'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('file')),
    __param(0, (0, common_1.UploadedFile)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, UploadFileEspDTO_1.UploadFileEspDTO]),
    __metadata("design:returntype", Promise)
], espController.prototype, "uploadFile", null);
exports.espController = espController = __decorate([
    (0, common_1.Controller)('esp'),
    __metadata("design:paramtypes", [esp_service_1.espDetectionService])
], espController);
//# sourceMappingURL=esp.controller.js.map