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
Object.defineProperty(exports, "__esModule", { value: true });
exports.DatabaseConfigController = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("typeorm");
let DatabaseConfigController = class DatabaseConfigController {
    datasource;
    constructor(datasource) {
        this.datasource = datasource;
    }
    async healthCheck() {
        if (!this.datasource.isInitialized) {
            return { status: 'error', db: 'not connected !' };
        }
        try {
            await this.datasource.query('SELECT 1');
            return { status: 'ok', db: 'connected !' };
        }
        catch (e) {
            return { status: 'error', db: 'not connected !', message: e.message };
        }
    }
};
exports.DatabaseConfigController = DatabaseConfigController;
__decorate([
    (0, common_1.Get)('health'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], DatabaseConfigController.prototype, "healthCheck", null);
exports.DatabaseConfigController = DatabaseConfigController = __decorate([
    (0, common_1.Controller)('databaseConfig'),
    __metadata("design:paramtypes", [typeorm_1.DataSource])
], DatabaseConfigController);
//# sourceMappingURL=databaseConfig.controller.js.map