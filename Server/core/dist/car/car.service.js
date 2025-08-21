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
exports.CarsService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const car_entity_1 = require("./entities/car.entity");
let CarsService = class CarsService {
    carRepo;
    constructor(carRepo) {
        this.carRepo = carRepo;
    }
    async findAll() {
        return this.carRepo.find({ relations: ['user', 'plan'] });
    }
    async findOne(car_id) {
        const car = await this.carRepo.findOne({
            where: { car_id },
            relations: ['user', 'plan'],
        });
        if (!car)
            throw new common_1.NotFoundException(`Car with ID ${car_id} not found`);
        return car;
    }
    async findCarWithLicensePlate(licensePlate) {
        const car = await this.carRepo.findOne({
            where: { license_plate: licensePlate },
            relations: ['user', 'plan'],
        });
        if (!car)
            throw new common_1.NotFoundException(`Car with license plate ${licensePlate} not found`);
        return car;
    }
    async findUserByLicensePlate(licensePlate) {
        const car = await this.carRepo.findOne({
            where: { license_plate: licensePlate },
            relations: ['user'],
        });
        if (!car) {
            throw new common_1.NotFoundException(`Car with license plate ${licensePlate} not found`);
        }
        return car.user;
    }
    async create(carData) {
        const car = this.carRepo.create(carData);
        return this.carRepo.save(car);
    }
    async update(car_id, updateData) {
        await this.carRepo.update(car_id, updateData);
        return this.findOne(car_id);
    }
    async remove(car_id) {
        const result = await this.carRepo.delete(car_id);
        if (result.affected === 0) {
            throw new common_1.NotFoundException(`Car with ID ${car_id} not found`);
        }
    }
};
exports.CarsService = CarsService;
exports.CarsService = CarsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(car_entity_1.Car)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], CarsService);
//# sourceMappingURL=car.service.js.map