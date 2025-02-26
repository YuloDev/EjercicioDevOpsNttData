const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();
const API_KEY = '2f5ae96c-b558-4c7b-a590-a501ae1c3f6c';
const JWT_SECRET = 'supersecretkey';
const PORT = process.env.PORT || 8080;
const token = jwt.sign({ to: 'Juan', from: 'Maria', timestamp: Date.now() }, JWT_SECRET);
app.use(express.json());

app.post('/DevOps', (req, res, next) => {
    const apiKey = req.header('X-Parse-REST-API-Key');
    const token = req.header('X-JWT-KWY');

    if (apiKey !== API_KEY) {
        return res.status(401).json({ error: 'API Key inválida' });
    }

    if (!token) {
        return res.status(401).json({ error: 'JWT es requerido' });
    }

    try {
        jwt.verify(token, JWT_SECRET);
    } catch (err) {
        return res.status(401).json({ error: 'JWT inválido' });
    }
    next();
});

app.post('/DevOps', (req, res) => {
    const { message, to, from, timeToLifeSec } = req.body;

    if (message && to && from && timeToLifeSec) {
        const newToken = jwt.sign({ to, from, timestamp: Date.now() }, JWT_SECRET, { expiresIn: timeToLifeSec });
        res.set('X-Generated-JWT', newToken);

        return res.json({ message: `Hello ${to} your message will be sent` });
    }

    res.status(400).json({ error: 'Payload inválido' });
});

app.all('/DevOps', (req, res) => {
    res.status(405).send('ERROR');
});


const server = app.listen(PORT, () => {
    console.log(`Servidor corriendo en el puerto ${PORT}`);
    console.log(`jwt ${token}`);
});

module.exports = server;
