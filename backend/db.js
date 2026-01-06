import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config();

mongoose.connect(process.env.MONGOURL);

const db = mongoose.connection;

db.on('connected', () => {
    console.log('MongoDB connected successfully');
});

db.on('error', (err) => {
    console.error('MongoDB connection error:', err);
});
db.on('disconnected', () => {
    console.log('MongoDB disconnected');
});

export default db;
