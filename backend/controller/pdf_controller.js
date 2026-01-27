import Subject from '../models/subject.js';
import Pdf from '../models/pdf.js'

export const uploadNotePdf = async (req,res)=>{
    console.log("fileeeeee");
    try {

        if (!req.file) {
            return res.status(400).json({ error: "PDF required" });
        }

        const pdf = req.file.path || req.file.secure_url || req.file.url;


        const {semester,subject,chapterName,noteType} = req.body;
        
        const newPdf = new Pdf({
            semester:semester,
            subject:subject,
            chapter:chapterName,
            noteType:noteType,
            pdf:pdf,
        });
        await newPdf.save();
        let subjectExist = await Subject.findOne({
            subject:subject,
            noteType:noteType,
            semester:semester
        });
        if(subjectExist){
            subjectExist.chapters.push(newPdf._id);
        }
        else{
            subjectExist = new Subject(
                {
                    semester:semester,
                    subject:subject,
                    chapters:[newPdf._id],
                    noteType:noteType,
                }
            );
        }
        console.log("pdf saved");
        await subjectExist.save();
        res.status(200).json(true);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
}

export const getPdf = async (req,res)=>{
    try {
        const {subject,noteType,semester} = req.query;
        const notes = await Pdf.find(
            {
                subject:subject,
                semester:semester,
                noteType:noteType
            }
        );
        console.log(`${subject},${noteType} pdf fetched`);
        res.status(200).json(notes);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
}


export const uploadPdf= async(req,res)=>{
    try {
        if (!req.file) {
            return res.status(400).json({ error: "PDF required" });
        }

        const pdf = req.file.path || req.file.secure_url || req.file.url;
        res.status(200).json({pdf});
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
}