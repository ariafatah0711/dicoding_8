const amqp = require('amqplib');
(async () => {
  try {
    const conn = await amqp.connect('amqp://admin:admin123@192.168.49.2:30006');
    console.log('✅ Connected!');
  } catch (err) {
    console.error(err);
  }
})();
