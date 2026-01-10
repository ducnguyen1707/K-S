const express = require('express');
const db = require('./db.js');
const app = express();
app.use(express.json());

app.get('/', (req, res) => {  
    res.send('Hello World from Node.js server!');  // Update res: get index page 
});

app.get('/api/check', (req, res) => {
    res.status(200).send('healthy');  // Update res: 200 health check
});

app.post('/api/user',async (req, res) => {
    const { name, age } = req.body; //Update req: get user data
    try{
        const [result] = await db.execute(
            "INSERT INTO users (name, age) VALUES (?, ?)",
            [name, age]
        )
    }catch (err){
        res.status(500).json({error: err.message}); //Update res: catch 500
    }
})

app.get('/api/users', async (req, res) => {
    try{
        const [row] = await db.execute("SELECT * FROM users");
        res.json(row); //Update res: get all users
    }catch (err){
    res.status(500).json({error: err.message}); //Update res: catch 500
}
})

app.get('/api/user/:id', async (req, res) => {
    try{
        const [row]  = await db.execute("SELECT * FROM users WHERE id = ?",
            req.params.id) ; //Update req: get user by id
    }catch (err){
        res.status(500).json({error: err.message}); //Update res: catch 500
    }
})

app.put('/api/users/:id', async (req, res) => {
    const { name, age} = req.body; //Update req: update user data
    try{
        const [result] = await db.execute(
            "UPDATE users SET name = ? , age = ? WHERE id =?", 
            [name, age, req.params.id]);
            res.json({update: result.affectedRows > 0}) //Update res: update success
    }catch (err){
        res.status(500).json({error: err.message}); //Update res: catch 500
    }
})

app.delete('/api/users/:id', async (req, res) => {
    try{
        const [result] = await db.execute(
            "DELETE FROM users WHERE id = ?", 
            req.params.id); //Update req: delete user by id
            res.json({deleted: result.affectedRows > 0}) //Update res: delete success
    }catch (err){
        res.status(500).json({error: err.message}); //Update res: catch 500
    }
})

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});