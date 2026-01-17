# Backend Authorization Check Checklist

## ✅ Frontend Status: WORKING CORRECTLY

**Verified from logs:**
```
✅ Authorization Header: Bearer 139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d
✅ Request Method: POST
✅ Request URL: http://helper.nexltech.com/public/api/job-post
✅ All fields present: job_title, job_category_id, payment, address, date_time, job_description
✅ Image file included
```

## ❌ Backend Issue: 403 Unauthorized

**The frontend is sending everything correctly. The backend is rejecting the request.**

## Frontend Request Details
- **Endpoint**: `POST http://helper.nexltech.com/public/api/job-post`
- **Content-Type**: `multipart/form-data`
- **Authorization Header**: `Bearer 139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d`
- **Token Format**: Laravel Sanctum format (`user_id|token`)
- **User ID from token**: 139

## What to Check on Backend

### 1. Verify Authorization Header is Received
Check your backend logs or middleware to confirm the header arrives:
```php
// Example Laravel check
$authHeader = $request->header('Authorization');
// Should return: "Bearer 139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d"

Log::info('Received Authorization:', $authHeader);
```

### 2. Check Authentication Middleware
Ensure the route is protected:
```php
Route::post('/job-post', [JobController::class, 'store'])
    ->middleware('auth:sanctum'); // or your auth middleware
```

### 3. Token Validation - CRITICAL CHECKS

**Token being sent:** `139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d`

**Check these in order:**

#### A. Check if token exists in database:
```sql
-- For Laravel Sanctum
SELECT * FROM personal_access_tokens 
WHERE tokenable_id = 139 
AND token LIKE 'u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d%';
```

**Note:** Sanctum might hash tokens. Check if the token in database is:
- Stored as plain text (should match)
- Stored as hash (need to verify with `Hash::check()`)

#### B. Check if token is expired:
```sql
SELECT expires_at, created_at 
FROM personal_access_tokens 
WHERE tokenable_id = 139;
```
- Verify `expires_at` is NULL or in the future
- Check `last_used_at` if available

#### C. Check if token is revoked:
```sql
SELECT * FROM personal_access_tokens 
WHERE tokenable_id = 139 
AND revoked = 0; -- Should be 0 (not revoked)
```

#### D. Check if user exists and is active:
```sql
SELECT id, email, status, role 
FROM users 
WHERE id = 139;
```
- Verify user exists
- Check if user account is active/enabled
- Verify user role allows job creation

### 4. Debug Backend Response - ADD THIS CODE

Add this to your JobController `store` method or middleware:

```php
public function store(Request $request) {
    // Log everything
    \Log::info('=== JOB POST REQUEST DEBUG ===');
    \Log::info('Request Headers:', $request->headers->all());
    \Log::info('Authorization Header:', $request->header('Authorization'));
    \Log::info('Content-Type:', $request->header('Content-Type'));
    
    // Check authentication
    if (!$request->user()) {
        \Log::error('User not authenticated');
        \Log::error('Bearer token:', [substr($request->bearerToken(), 0, 20)]);
        return response()->json(['message' => 'Unauthorized'], 403);
    }
    
    \Log::info('Authenticated User:', [
        'id' => $request->user()->id,
        'email' => $request->user()->email,
        'role' => $request->user()->role
    ]);
    \Log::info('Request Data:', $request->all());
    \Log::info('===============================');
    
    // Continue with job creation...
}
```

### 5. Common Backend Issues

#### Issue 1: Token Hash Mismatch (Laravel Sanctum)
- **Problem:** Sanctum might be storing tokens as hashes
- **Solution:** Check if tokens table uses `hash` column or `token` column
- **Check:** Verify token format matches database format

#### Issue 2: Token Expired
- **Problem:** Token might have expired
- **Solution:** Check `expires_at` column in `personal_access_tokens` table
- **Fix:** Generate new token or extend expiry

#### Issue 3: User Not Active
- **Problem:** User account might be disabled/suspended
- **Solution:** Check user status in `users` table
- **Fix:** Ensure user account is active

#### Issue 4: Middleware Not Applied
- **Problem:** Route doesn't have authentication middleware
- **Solution:** Verify route has `auth:sanctum` or equivalent
- **Fix:** Add middleware to route definition

#### Issue 5: Token Belongs to Different User
- **Problem:** Token might not belong to user 139
- **Solution:** Verify `tokenable_id` matches `user_id` in tokens table
- **Fix:** Ensure token was issued to correct user

### 6. Quick Backend Checks

Run these commands/queries on your backend:

```bash
# Check if token route is working
curl -X POST http://helper.nexltech.com/public/api/job-post \
  -H "Authorization: Bearer 139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d" \
  -H "Accept: application/json" \
  -v
```

```sql
-- Check token in database
SELECT id, tokenable_id, token, name, abilities, last_used_at, expires_at, created_at
FROM personal_access_tokens
WHERE tokenable_id = 139
ORDER BY created_at DESC
LIMIT 5;

-- Check user
SELECT id, name, email, role, status, created_at
FROM users
WHERE id = 139;
```

### 7. Expected vs Actual

**✅ Frontend is sending correctly:**
```
Authorization: Bearer 139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d
Accept: application/json
Content-Type: multipart/form-data; boundary=<boundary>
```

**❌ Backend response:**
```json
{
  "message": "Unauthorized"
}
```

**Backend needs to:**
1. ✅ Receive `Authorization` header (should be there)
2. ❓ Extract token: `139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d`
3. ❓ Validate token in database
4. ❓ Authenticate user ID 139
5. ❓ Allow user 139 to create job posts

### 8. Next Steps for Backend Developer

1. **Add the debug logging code above** to see what backend receives
2. **Check the database** - verify token exists and is valid
3. **Check middleware** - ensure auth middleware is applied
4. **Check user permissions** - verify user 139 can create jobs
5. **Compare with working endpoints** - check how other authenticated endpoints work

### 9. If Token Validation is the Issue

If the token format `139|u8iG7dspnSnEvqyJY6UvSCpvIu4fhEDiZMiZug87147dc09d` doesn't match what's in your database:

- **Option 1:** Generate a new token by logging in again
- **Option 2:** Check if backend expects a different token format
- **Option 3:** Verify if tokens are hashed differently

The frontend code is working correctly - all headers and data are being sent properly.
