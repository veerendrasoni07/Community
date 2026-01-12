import multer from "multer";
import { storage } from "../controller/clodinary.js"

const upload = multer({
  storage,
  limits: { fileSize: 20 * 1024 * 1024 }, // 20MB
});

export default upload;
