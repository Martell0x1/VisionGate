import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import * as mqtt from 'mqtt';

@Injectable()
export class MqttService implements OnModuleInit, OnModuleDestroy {
  private client: mqtt.MqttClient;

  onModuleInit() {
    const brokerUrl =
      'mqtts://5965aa9309824cb48daa5da0a2083f47.s1.eu.hivemq.cloud:8883';

    this.client = mqtt.connect(brokerUrl, {
      username: 'Maro1234',
      password: 'Maro@012',
      protocol: 'mqtts', // TLS
      reconnectPeriod: 2000,
    });

    this.client.on('connect', () => {
      console.log('✅ Connected to HiveMQ broker');
    });

    this.client.on('error', (err) => {
      console.error('❌ MQTT connection error:', err);
    });
  }

  publish(topic: string, message: string) {
    if (this.client.connected) {
      this.client.publish(topic, message, { qos: 1 }, (err) => {
        if (err) console.error('❌ Publish error:', err);
        else console.log(`📤 Published to ${topic}: ${message}`);
      });
    } else {
      console.error('⚠️ Cannot publish, MQTT client not connected');
    }
  }

  subscribe(topic: string) {
    this.client.subscribe(topic, { qos: 1 }, (err) => {
      if (err) console.error('❌ Subscribe error:', err);
      else console.log(`📥 Subscribed to ${topic}`);
    });
  }

  onModuleDestroy() {
    if (this.client) {
      this.client.end();
    }
  }
}
