import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  console.log('Starting NestJS application...');
  const app = await NestFactory.create(AppModule, {
    logger: ['log', 'error', 'warn', 'debug', 'verbose'], // Enable all logs for development
  });

  const config = new DocumentBuilder()
    .setTitle('IntelliGarage API')
    .setDescription('API documentation for IntelliGarage backend')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api_docs', app, document);
  
  // To solve error of connection of flutter app.
  app.enableCors({
    origin: '*', // Allows all origins (for development purposes)
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    allowedHeaders: 'Content-Type, Accept',
  });

  await app.listen(process.env.PORT ?? 3000);
  console.log('App is running on localhost:3000...');
}
bootstrap();