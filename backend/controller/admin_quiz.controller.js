import Quiz from "../models/quiz.js";

const ALLOWED_DIFFICULTY = ["Easy", "Medium", "Hard"];

const normalizeQuestion = (question) => ({
    questionText: question.questionText?.trim(),
    options: Array.isArray(question.options)
        ? question.options.map((option) => option?.toString().trim())
        : [],
    correctAnswer: Number(question.correctAnswer)
});

const validateQuizPayload = ({ quizName, quizDifficulty, points, questions }) => {
    if (!quizName || !quizDifficulty || points === undefined || !Array.isArray(questions)) {
        return "Missing required fields";
    }

    if (!ALLOWED_DIFFICULTY.includes(quizDifficulty)) {
        return "Invalid quiz difficulty";
    }

    if (!Number.isFinite(Number(points)) || Number(points) < 0) {
        return "Points must be a non-negative number";
    }

    if (questions.length === 0) {
        return "At least one question is required";
    }

    for (const question of questions) {
        if (!question.questionText || !Array.isArray(question.options)) {
            return "Question text and options are required";
        }
        if (question.options.length !== 4) {
            return "Each question must have exactly 4 options";
        }
        if (!Number.isInteger(question.correctAnswer) || question.correctAnswer < 0 || question.correctAnswer > 3) {
            return "Correct answer index must be between 0 and 3";
        }
    }

    return null;
};

const requireAdmin = (req, res) => {
    if (req.user?.role !== "admin") {
        res.status(403).json({ msg: "Only admin can manage quizzes" });
        return false;
    }
    return true;
};

export const createQuizController = async (req, res) => {
    try {
        if (!requireAdmin(req, res)) return;

        const {
            quizName,
            quizBanner,
            quizDifficulty,
            points,
            questions,
            setActive = true
        } = req.body;

        const normalizedQuestions = (questions || []).map(normalizeQuestion);
        const validationError = validateQuizPayload({
            quizName,
            quizDifficulty,
            points,
            questions: normalizedQuestions
        });
        if (validationError) {
            return res.status(400).json({ msg: validationError });
        }

        if (setActive) {
            await Quiz.updateMany({}, { $set: { isActive: false } });
        }

        const quiz = await Quiz.create({
            quizName: quizName.trim(),
            quizBanner: quizBanner?.trim() || "",
            quizDifficulty,
            points: Number(points),
            isActive: Boolean(setActive),
            createdBy: req.user.id,
            questions: normalizedQuestions
        });

        return res.status(200).json({ success: true, quiz });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};

export const listAllQuizController = async (req, res) => {
    try {
        if (!requireAdmin(req, res)) return;

        const quizzes = await Quiz.find({})
            .select("_id quizName quizDifficulty points isActive createdAt questions")
            .sort({ createdAt: -1 });

        const payload = quizzes.map((quiz) => ({
            _id: quiz._id,
            quizName: quiz.quizName,
            quizDifficulty: quiz.quizDifficulty,
            points: quiz.points,
            isActive: quiz.isActive,
            createdAt: quiz.createdAt,
            totalQuestions: quiz.questions.length
        }));

        return res.status(200).json({ success: true, quizzes: payload });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};

export const activateQuizController = async (req, res) => {
    try {
        if (!requireAdmin(req, res)) return;

        const { quizId } = req.params;
        const quiz = await Quiz.findById(quizId);
        if (!quiz) {
            return res.status(404).json({ msg: "Quiz not found" });
        }

        await Quiz.updateMany({}, { $set: { isActive: false } });
        quiz.isActive = true;
        await quiz.save();

        return res.status(200).json({ success: true, msg: "Quiz activated" });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};

export const deleteQuizController = async (req, res) => {
    try {
        if (!requireAdmin(req, res)) return;

        const { quizId } = req.params;
        const deleted = await Quiz.findByIdAndDelete(quizId);
        if (!deleted) {
            return res.status(404).json({ msg: "Quiz not found" });
        }

        if (deleted.isActive) {
            const latest = await Quiz.findOne().sort({ createdAt: -1 });
            if (latest) {
                latest.isActive = true;
                await latest.save();
            }
        }

        return res.status(200).json({ success: true, msg: "Quiz deleted" });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};
