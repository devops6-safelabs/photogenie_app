//import packages
const express =require ('express');
const mongoose= require('mongoose');

// import all files
const authRouter= require("./routes/auth");

//Init
const PORT=3000;
const app =express();
const dbURL ='mongodb+srv://avotraismael4:ismavotra586@cluster0.wyn7zrc.mongodb.net/?retryWrites=true&w=majority'

//middleware 
app.use(express.json());
app.use(authRouter);

//Database connect
mongoose.connect(dbURL).then(()=>{
    console.log('Connection successful');
}).catch(e=>{
    console.log(e);
});

app.listen(PORT,()=>{
    console.log(`Connect at port ${PORT}`);
});