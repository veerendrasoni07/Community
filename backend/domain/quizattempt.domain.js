class QuizAttempt{


    constructor(userId,quizId,answers,totalQuestions ){
        if(!answers){
            throw new Error("~ Answers are not provided");
        }
        if(Object.keys(answers).length > Object.keys(totalQuestions).length){
            throw new Error("Answers are more than questions~");
        }


        this.answers = answers;
        this.quizId = quizId;
        this.userId = userId;
        this.totalQuestions = totalQuestions;
    }

    

    calculateScore(correctAnswers){
       if(!correctAnswers){
        throw new Error("Correct answers are missing");
       }
        let score = 0;

        for (const qId in this.questions) {
            const correctAnswer = this.questions[qId];
            const userAnswer = this.answers[qId];
            if (userAnswer === undefined) {
                score += this.scoringRule.unanswered;
            } else if (userAnswer === correctAnswer) {
                score += this.scoringRule.correct;
            } else {
                score += this.scoringRule.wrong;
            }
        }

        return Math.max(score, this.scoringRule.minScore);
    }



}
export default QuizAttempt;