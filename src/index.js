const get = require('lodash.get');
const AWS = require('aws-sdk');

const s3 = new AWS.S3({
    region: 'ap-southeast-2',
});

exports.handler = async function () {
    const s3Response = await s3.getObject({
        Bucket: process.env.S3_BUCKET,
        Key: 'response.json',
    }).promise();
    const body = JSON.parse(s3Response.Body.toString('utf-8'));
    return {
        message: get(body, "message"),
    };
};
