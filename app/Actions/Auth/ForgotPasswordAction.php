<?php

namespace App\Actions\Auth;

use Exception;
use Illuminate\Support\Facades\Password;

class ForgotPasswordAction
{
    public function execute(string $email): void
    {
        $status = Password::sendResetLink(['email' => $email]);

        if ($status !== Password::RESET_LINK_SENT) {
            throw new Exception('Gagal mengirim tautan reset password.', 400);
        }
    }
}
