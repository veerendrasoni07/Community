import express from 'express';
import multer from 'multer';
import { uploadNotePdf,getPdf, uploadPdf } from '../controller/pdf_controller.js';
const pdfRoutes = express.Router();
import {storage} from '../controller/clodinary.js';
import { auth } from '../middleware/auth.js';
import pdf from '../models/pdf.js';

const upload = multer({storage});

pdfRoutes.post('/api/upload-note-pdf',upload.single("pdf"),uploadNotePdf);
pdfRoutes.get('/api/get-pdf',getPdf);
pdfRoutes.post('/api/upload-pdf',upload.single("pdf"),uploadPdf);

export default pdfRoutes;
