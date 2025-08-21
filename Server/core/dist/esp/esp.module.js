"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.espModule = void 0;
const common_1 = require("@nestjs/common");
const esp_controller_1 = require("./esp.controller");
const esp_service_1 = require("./esp.service");
const platform_express_1 = require("@nestjs/platform-express");
const multer_1 = require("multer");
const ml_module_1 = require("../ml/ml.module");
const car_module_1 = require("../car/car.module");
let espModule = class espModule {
};
exports.espModule = espModule;
exports.espModule = espModule = __decorate([
    (0, common_1.Module)({
        imports: [
            platform_express_1.MulterModule.register({
                storage: (0, multer_1.diskStorage)({}),
            }),
            ml_module_1.MlModule,
            car_module_1.CarModule,
        ],
        controllers: [esp_controller_1.espController],
        providers: [esp_service_1.espDetectionService],
        exports: [esp_service_1.espDetectionService],
    })
], espModule);
//# sourceMappingURL=esp.module.js.map