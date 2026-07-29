<?php

namespace App\Actions\Classroom;

use App\Models\ClassRoom;

class DeleteClassroomAction
{
    public function execute(ClassRoom $class): void
    {
        $class->delete();
    }
}
