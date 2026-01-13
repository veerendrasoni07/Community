import express from 'express';
import multer from 'multer';
import { uploadPdf,getPdf } from '../controller/pdf_controller.js';
const pdfRoutes = express.Router();
import {storage} from '../controller/clodinary.js';
import { auth } from '../middleware/auth.js';

const upload = multer({storage});

pdfRoutes.post('/api/upload-pdf',upload.single("pdf"),uploadPdf);
pdfRoutes.get('/api/get-pdf',auth,getPdf);

export default pdfRoutes;
