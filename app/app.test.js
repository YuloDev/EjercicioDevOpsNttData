const request = require('supertest');
const jwt = require('jsonwebtoken');
const server = require('./server');

const API_KEY = '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c';
const JWT_SECRET = 'supersecretkey';

const validToken = jwt.sign({ to: 'Juan', from: 'Maria', timestamp: Date.now() }, JWT_SECRET, { expiresIn: '1h' });

describe('Microservicio DevOps', () => {

    test('Debe rechazar solicitudes sin API Key', async () => {
        const res = await request(server)
            .post('/DevOps')
            .set('Content-Type', 'application/json')
            .send({ message: 'Hello', to: 'Juan', from: 'Maria', timeToLifeSec: 45 });

        expect(res.status).toBe(401);
        expect(res.body.error).toBe('API Key inválida');
    });

    test('Debe rechazar solicitudes sin JWT', async () => {
        const res = await request(server)
            .post('/DevOps')
            .set('X-Parse-REST-API-Key', API_KEY)
            .set('Content-Type', 'application/json')
            .send({ message: 'Hello', to: 'Juan', from: 'Maria', timeToLifeSec: 45 });

        expect(res.status).toBe(401);
        expect(res.body.error).toBe('JWT es requerido');
    });

    test('Debe rechazar solicitudes con JWT inválido', async () => {
        const res = await request(server)
            .post('/DevOps')
            .set('X-Parse-REST-API-Key', API_KEY)
            .set('X-JWT-KWY', 'token-invalido')
            .set('Content-Type', 'application/json')
            .send({ message: 'Hello', to: 'Juan', from: 'Maria', timeToLifeSec: 45 });

        expect(res.status).toBe(401);
        expect(res.body.error).toBe('JWT inválido');
    });

    test('Debe rechazar solicitudes con payload inválido', async () => {
        const res = await request(server)
            .post('/DevOps')
            .set('X-Parse-REST-API-Key', API_KEY)
            .set('X-JWT-KWY', validToken)
            .set('Content-Type', 'application/json')
            .send({ message: 'Hello', to: 'Juan' });

        expect(res.status).toBe(400);
        expect(res.body.error).toBe('Payload inválido');
    });

    test('Debe aceptar una solicitud válida y devolver un nuevo JWT', async () => {
        const res = await request(server)
            .post('/DevOps')
            .set('X-Parse-REST-API-Key', API_KEY)
            .set('X-JWT-KWY', validToken)
            .set('Content-Type', 'application/json')
            .send({ message: 'Hello', to: 'Juan', from: 'Maria', timeToLifeSec: 45 });

        expect(res.status).toBe(200);
        expect(res.body.message).toBe('Hello Juan your message will be sent');
        expect(res.headers['x-generated-jwt']).toBeDefined();
    });

    test('Debe rechazar otros métodos HTTP con ERROR', async () => {
        const res = await request(server).get('/DevOps');
        expect(res.status).toBe(405);
        expect(res.text).toBe('ERROR');
    });

    afterAll(() => {
        server.close();
    });
});
