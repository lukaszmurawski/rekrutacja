<?php

declare(strict_types=1);

namespace App\UserInterface\Web\Request;

use Symfony\Component\Validator\Constraints as Assert;

class UserFilterRequest
{
    #[Assert\Regex(
        pattern: '/^[A-Za-zÀ-žąĄćĆęĘłŁńŃóÓśŚżŻźŹ \-]+$/u',
        message: 'Incorrect characters'
    )]
    public ?string $first_name = null;

    #[Assert\Regex(
        pattern: '/^[A-Za-zÀ-žąĄćĆęĘłŁńŃóÓśŚżŻźŹ \-]+$/u',
        message: 'Incorrect characters'
    )]
    public ?string $last_name = null;

    #[Assert\Date]
    public ?string $birthdate_from = null;

    #[Assert\Date]
    public ?string $birthdate_to = null;

    #[Assert\Choice(['male', 'female'])]
    public ?string $gender = null;

    #[Assert\Choice(['first_name', 'last_name', 'gender', 'birthdate'])]
    public ?string $sort_by = null;

    #[Assert\Choice(['asc', 'desc'])]
    public ?string $sort_dir = null;
}