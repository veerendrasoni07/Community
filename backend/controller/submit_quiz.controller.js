import Quiz from "../models/quiz.js";
import QuizAttempt from "../models/quiz_attempt.js";

const SAMPLE_QUIZ = {
    quizName: "Daily DSA Challenge",
    quizBanner: "https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1400&q=80",
    quizDifficulty: "Medium",
    points: 10,
    isActive: true,
    questions: [
        {
            questionText: "Which data structure follows LIFO order?",
            options: ["Queue", "Stack", "Linked List", "Heap"],
            correctAnswer: 1
        },
        {
            questionText: "What is the average time complexity of binary search?",
            options: ["O(n)", "O(log n)", "O(n log n)", "O(1)"],
            correctAnswer: 1
        },
        {
            questionText: "Which traversal gives sorted output in a Binary Search Tree?",
            options: ["Preorder", "Postorder", "Level order", "Inorder"],
            correctAnswer: 3
        },
        {
            questionText: "Which algorithm is used to find shortest path in weighted graphs without negative edges?",
            options: ["DFS", "BFS", "Dijkstra", "KMP"],
            correctAnswer: 2
        },
        {
            questionText: "Which sorting algorithm is stable by default?",
            options: ["Quick Sort", "Merge Sort", "Heap Sort", "Selection Sort"],
            correctAnswer: 1
        }
    ]
};

const sanitizeQuiz = (quiz) => ({
    _id: quiz._id,
    quizName: quiz.quizName,
    quizBanner: quiz.quizBanner,
    quizDifficulty: quiz.quizDifficulty,
    points: quiz.points,
    totalQuestions: quiz.questions.length,
    questions: quiz.questions.map((q, index) => ({
        id: q._id ?? index,
        questionText: q.questionText,
        options: q.options
    }))
});

const normalizeAnswers = (answers) => {
    if (Array.isArray(answers)) {
        return answers.map((value) => {
            const parsed = Number(value);
            return Number.isInteger(parsed) ? parsed : -1;
        });
    }

    if (answers && typeof answers === "object") {
        const entries = Object.entries(answers);
        entries.sort((a, b) => Number(a[0]) - Number(b[0]));
        return entries.map(([, value]) => {
            const parsed = Number(value);
            return Number.isInteger(parsed) ? parsed : -1;
        });
    }

    return [];
};

const ensureQuizExists = async () => {
    let quiz = await Quiz.findOne({ isActive: true }).sort({ createdAt: -1 });
    if (!quiz) {
        quiz = await Quiz.findOne().sort({ createdAt: -1 });
    }
    if (!quiz) {
        quiz = await Quiz.create(SAMPLE_QUIZ);
    }
    return quiz;
};

export const getActiveQuizController = async (req, res) => {
    try {
        const quiz = await ensureQuizExists();
        return res.status(200).json({ success: true, quiz: sanitizeQuiz(quiz) });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};

export const getQuizByIdController = async (req, res) => {
    try {
        const quiz = await Quiz.findById(req.params.quizId);
        if (!quiz) {
            return res.status(404).json({ msg: "Quiz not found" });
        }
        return res.status(200).json({ success: true, quiz: sanitizeQuiz(quiz) });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};

export const submitQuizController = async (req, res) => {
    try {
        const { quizId, answers } = req.body;
        const userId = req.user?.id ?? req.body.userId;

        if (!userId || !quizId || answers === undefined) {
            return res.status(400).json({ msg: "Fields are missing" });
        }

        const quiz = await Quiz.findById(quizId);
        if (!quiz) {
            return res.status(404).json({ msg: "Quiz not found" });
        }

        const normalizedAnswers = normalizeAnswers(answers);
        const correctAnswers = quiz.questions.map((question) => question.correctAnswer);
        const totalQuestions = correctAnswers.length;

        let correctCount = 0;
        const resultBreakdown = quiz.questions.map((question, index) => {
            const selected = normalizedAnswers[index] ?? -1;
            const isCorrect = selected === question.correctAnswer;
            if (isCorrect) correctCount += 1;
            return {
                questionId: question._id,
                selectedAnswer: selected,
                correctAnswer: question.correctAnswer,
                isCorrect
            };
        });

        const score = correctCount * (quiz.points || 1);
        const attempt = await QuizAttempt.create({
            user: userId,
            quiz: quizId,
            score,
            answers: resultBreakdown
        });

        return res.status(200).json({
            success: true,
            data: {
                attemptId: attempt._id,
                quizId,
                correctCount,
                totalQuestions,
                score,
                accuracy: totalQuestions === 0 ? 0 : Number(((correctCount / totalQuestions) * 100).toFixed(2))
            }
        });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};

export const getMyQuizAttemptsController = async (req, res) => {
    try {
        const userId = req.user?.id;
        if (!userId) {
            return res.status(401).json({ msg: "Unauthenticated" });
        }

        const attempts = await QuizAttempt.find({ user: userId })
            .populate("quiz", "quizName quizDifficulty")
            .sort({ _id: -1 })
            .limit(20);

        return res.status(200).json({ success: true, attempts });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ error: "Internal Server Error" });
    }
};
