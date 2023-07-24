const express =require ('express');
const User = require('../models/user');
const authRouter= express.Router();
const bcryptjs=require('bcryptjs')

authRouter.post('/api/signup', async (req,res)=>{
    try {
    //get data from the client
    const {name,lastname,email,password,birthday,username,phone,country}=req.body;
    
    //post that data in database
    const existinguser =await User.findOne({email})
    if (existinguser) {
        return res.status(400).json({msg:'User with same email is already exists!'})
    }

    const hashedPassword =await bcryptjs.hash(password,8)
    
    let user = new User({
        email,
        password: hashedPassword,
        name,
        lastname,
        birthday,
        username,
        phone,
        country,
    })
    
    user = await user.save();
    res.json(user);

    //return the data to the user
    } catch (e) {
    res.status(500).json({error: e.message});
}

});
 
module.exports=authRouter;
