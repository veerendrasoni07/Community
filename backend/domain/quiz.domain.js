class Quiz {

    constructor({ topic, questions }) {
        if (!topic) {
            throw new Error("Quiz topic is required");
        }

        if (!Array.isArray(questions) || questions.length === 0) {
            throw new Error("Quiz must have questions");
        }

        this.topic = topic;
        this.questions = questions;

        this.validateQuestions();
    }

    validateQuestions() {
        for (const question of this.questions) {
            this.validateQuestion(question);
        }
    }

    validateQuestion(question) {
        const {
            questionText,
            options,
            correctOption,
            difficulty,
            explanation
        } = question;

        if (!questionText) {
            throw new Error("Question text missing");
        }

        if (!Array.isArray(options) || options.length !== 4) {
            throw new Error("Each question must have exactly 4 options");
        }

        if (
            correctOption === undefined ||
            correctOption < 0 ||
            correctOption > 3
        ) {
            throw new Error("Correct option must be between 0 and 3");
        }

        if (!["easy", "medium", "hard"].includes(difficulty)) {
            throw new Error("Invalid difficulty");
        }

        if (!explanation) {
            throw new Error("Explanation is mandatory");
        }
    }
}

export default Quiz;
