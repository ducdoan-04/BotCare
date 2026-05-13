const BASE_URL = 'http://localhost:3000/api/v1';
let token = '';
let staffId = 's1111111-1111-1111-1111-111111111111'; // Kathryn Murphy from seed

async function runTests() {
  try {
    console.log('--- 1. Testing Login ---');
    const loginRes = await fetch('http://localhost:3000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        email: 'receptionist@carebot.com',
        password: 'password123'
      })
    });
    const loginData = await loginRes.json();
    token = loginData.accessToken;
    if (!token) throw new Error('Login failed: ' + JSON.stringify(loginData));
    console.log('Login Success!');

    const headers = { 
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    };

    console.log('\n--- 2. Testing Staff List ---');
    const staffListRes = await fetch(`${BASE_URL}/staff`, { headers });
    const staffListData = await staffListRes.json();
    console.log(`Found ${staffListData.data.length} staff members.`);

    console.log('\n--- 3. Testing Staff List Filter (Nurse) ---');
    const nurseRes = await fetch(`${BASE_URL}/staff?role=Nurse`, { headers });
    const nurseData = await nurseRes.json();
    console.log(`Found ${nurseData.data.length} nurses.`);

    console.log('\n--- 4. Testing Staff Detail ---');
    const detailRes = await fetch(`${BASE_URL}/staff/${staffId}`, { headers });
    const detailData = await detailRes.json();
    console.log('Detail Success:', detailData.data.full_name);

    console.log('\n--- 5. Testing Staff Summary (Dynamic Calculation) ---');
    const summaryRes = await fetch(`${BASE_URL}/staff/${staffId}/summary`, { headers });
    const summaryData = await summaryRes.json();
    console.log('In Company:', summaryData.data.in_company.label);
    console.log('Attendance Rate:', summaryData.data.attendance_rate.label);

    console.log('\n--- 6. Testing Staff Timetable (Tasks & Heatmap) ---');
    const timetableRes = await fetch(`${BASE_URL}/staff/${staffId}/timetable`, { headers });
    const timetableData = await timetableRes.json();
    console.log(`Tasks for today: ${timetableData.data.today_tasks.length}`);
    console.log(`Attendance records (for Heatmap): ${timetableData.data.attendance_report.length}`);

    console.log('\n--- ALL STAFF LOGIC TESTS PASSED SUCCESSFULLY ---');
  } catch (error) {
    console.error('\n--- TEST FAILED ---');
    console.error(error.message);
    process.exit(1);
  }
}

runTests();
