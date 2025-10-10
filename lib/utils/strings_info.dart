Map<String, String> headers = {"Content-type": "application/json", "Auth-Key": "svrapi"};
// rzp_test_0gAUBx3H6twMaj
// Main Url
const String main_url = "https://svracademy.in/services/";
//const String main_url = "https://macsof.in/newsvr/services/";

// End Points
const String demo_course_api = "video/demoCoursesList";
const String registerapi = "users/create";
const String login_api = "users/passwordwithlogin";
const String live_courses_api = "course/courseList";
const String subjects_api = "course/getcourseSubjectsdetails";
const String materials_api = "subject/getsubjectbBystudymaterialdetails";
const String videos_api = "video/getsubjectbByVideodetails";
const String test_questions_api = "questions/testQuestionsList";
const String submit_test_api = "questions/examInsert";
const String profile_api = "users/getuserdetails";
const String confirm_payment_api = "users/payment";
const String mycourses ="questions/usersStudymaterialsList";
const String offlinecourses = "video/getsubjectbByOfflineVideodetails";
const String logout_api = "users/logout";
const String PaymentDetails_api="/users/getuserPaymentdetails";
const String resendOTP="/users/sendforgotOTPPassword";