import express from 'express';
import UserModel from '../models/Users.js';
const router = express.Router();

// Get all users with pagination and search
router.get('/users', async (req, res) => {
    try {
        const { page = 1, limit = 10, search = '' } = req.query;
        
        // Create search query
        const searchQuery = search
            ? {
                $or: [
                    { name: { $regex: search, $options: 'i' } },
                    { username: { $regex: search, $options: 'i' } },
                    { email: { $regex: search, $options: 'i' } },
                    { collegeName: { $regex: search, $options: 'i' } }
                ]
            }
            : {};

        // Get total count for pagination
        const totalUsers = await UserModel.countDocuments(searchQuery);

        // Fetch users with pagination
        const users = await UserModel
            .find(searchQuery)
            .select('name username email collegeName isVerified')
            .limit(limit * 1)
            .skip((page - 1) * limit)
            .exec();

        // Format response
        const formattedUsers = users.map(user => ({
            name: user.name,
            username: user.username,
            email: user.email,
            college: user.collegeName,
            veri: user.isVerified ? 'verified' : 'unverified'
        }));

        res.json({
            users: formattedUsers,
            totalPages: Math.ceil(totalUsers / limit),
            currentPage: page
        });

    } catch (error) {
        console.error('Error fetching users:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// get all community members
router.get('/api/community-member',async(req,res)=>{
    try {
        const members = await UserModel.find(
            {
                role:"community-member"
            }
        );
        console.log(members);
        res.status(200).json(members);
    } catch (error) {
        console.log(error);
        res.status(500).json({error:"Internal Server Error"});
    }
})



export default router;