import { Logger, ValidationPipe } from '@nestjs/common';

import { AppModule } from './app.module.js';
import { NestFactory } from '@nestjs/core';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const port = process.env.PORT ?? 3000;

  app.setGlobalPrefix('api');
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));

  await app.listen(port);
  Logger.log(`App running in port ${port}`, 'Bootstrap');
}
await bootstrap();
