class QuizGeneratorService {

    constructor(aiClient) {
        this.aiClient = aiClient;
    }

    async generate({ topic, difficulty, count }) {

        const prompt = `
Generate ${count} multiple-choice questions on topic "${topic}".

Rules:
- exactly 4 options per question
- only ONE correct option
- difficulty: ${difficulty}
- include explanation
- respond in strict JSON only
`;

        const response = await this.aiClient.generate(prompt);

        let parsed;
        try {
            parsed = JSON.parse(response);
        } catch {
            throw new Error("AI returned invalid JSON");
        }

        return parsed;
    }
}

export default QuizGeneratorService;
