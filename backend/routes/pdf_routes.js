import express from 'express';
import multer from 'multer';
import { uploadPdf } from '../controller/pdf_controller.js';
const pdfRoutes = express.Router();

const upload = multer()

pdfRoutes.post('/upload/pdf',)
